/*
 * SpagoBI, the Open Source Business Intelligence suite
 * � 2005-2015 Engineering Group
 *
 * This file is part of SpagoBI. SpagoBI is free software: you can redistribute it and/or modify it under the terms of the GNU
 * Lesser General Public License as published by the Free Software Foundation, either version 2.1 of the License, or any later version. 
 * SpagoBI is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details. You should have received
 * a copy of the GNU Lesser General Public License along with SpagoBI. If not, see: http://www.gnu.org/licenses/.
 * The complete text of SpagoBI license is included in the COPYING.LESSER file. 
 */
package it.eng.spagobi.engine.cockpit.api.association;

import java.util.List;

import it.eng.spagobi.engine.cockpit.CockpitEngine;
import it.eng.spagobi.engine.cockpit.api.AbstractCockpitEngineResource;
import it.eng.spagobi.engine.cockpit.association.Association;
import it.eng.spagobi.engine.cockpit.association.AssociationGroup;
import it.eng.spagobi.engine.cockpit.association.AssociationGroupJSONSerializer;
import it.eng.spagobi.engine.cockpit.association.AssociationJSONSerializer;
import it.eng.spagobi.engine.cockpit.association.AssociationManager;
import it.eng.spagobi.utilities.exceptions.SpagoBIServiceException;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * @author Andrea Gioia (andrea.gioia@eng.it)
 * 
 */
@Path("/1.0/associations")
public class AssociationResource extends AbstractCockpitEngineResource {
	
	static private Logger logger = Logger.getLogger(AssociationResource.class);
	
	@GET
	@Path("/")
	@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
	public String getAssociations() {
		
		logger.debug("IN");
		try {
			AssociationManager associationManager = this.getEngineInstance().getAssociationManager();
			List<Association> associations = associationManager.getAssociations();
			return serializeAssociations(associations).toString();
		} catch(Throwable t) {
			throw new SpagoBIServiceException(this.request.getPathInfo(), "An unexpected error occured while executing service", t);
		} finally {			
			logger.debug("OUT");
		}	
	}

	@POST
	@Path("/")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON + "; charset=UTF-8")
	public String setAssociations(String jsonData) {
		
		logger.debug("IN");
		try {
			JSONObject dataJSON = new JSONObject(jsonData);
			JSONArray associationsJSON = dataJSON.getJSONArray("items");
			List<Association> associations = deserializeAssociations(associationsJSON);
			
			AssociationManager associationManager = this.getEngineInstance().getAssociationManager();
			associationManager.addAssociations(associations);
			List<AssociationGroup> associationGroups = associationManager.getAssociationGroups();
			
			return serializeAssociationGroups(associationGroups).toString();
		} catch(Throwable t) {
			throw new SpagoBIServiceException(this.request.getPathInfo(), "An unexpected error occured while executing service", t);
		} finally {			
			logger.debug("OUT");
		}	
	}
	
	// =======================================================================
	// SERIALIZATION METHODS
	// =======================================================================
	
	private JSONArray serializeAssociations(List<Association> associations) {
		try {
			AssociationJSONSerializer serializer = new AssociationJSONSerializer();
			return serializer.serialize(associations);
		} catch(Throwable t) {
			throw new RuntimeException("An unexpected error occured while serializing results",  t);
		}	
	}
	
	private List<Association> deserializeAssociations(JSONArray associations) {
		try {
			AssociationJSONSerializer serializer = new AssociationJSONSerializer();
			return serializer.deserialize(associations);
		} catch(Throwable t) {
			throw new RuntimeException("An unexpected error occured while serializing results",  t);
		}	
	}
	
	private JSONArray serializeAssociationGroups(List<AssociationGroup> associationGroups) {
		try {
			AssociationGroupJSONSerializer serializer = new AssociationGroupJSONSerializer();
			return serializer.serialize(associationGroups);
		} catch(Throwable t) {
			throw new RuntimeException("An unexpected error occured while serializing results",  t);
		}	
	}

}