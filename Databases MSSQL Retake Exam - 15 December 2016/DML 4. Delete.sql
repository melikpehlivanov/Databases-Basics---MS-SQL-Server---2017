DELETE FROM Locations
  WHERE Id IN (
			   SELECT l.Id FROM Locations AS l
			   FULL JOIN Users AS u ON u.LocationId = l.Id
			   WHERE u.Id IS NULL
			   )