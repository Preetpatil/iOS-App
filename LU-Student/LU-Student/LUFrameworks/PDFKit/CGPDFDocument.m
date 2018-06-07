//
//	CGPDFDocument.m
//
//  Created by Abhishek P Mukundan on 20/09/16.
//  Copyright © 2016 SET INFOTECH PRIVATE LIMITED. All rights reserved.//


#import "CGPDFDocument.h"

//
//	CGPDFDocumentRef CGPDFDocumentCreateUsingUrl(CFURLRef, NSString *) function
//

CGPDFDocumentRef CGPDFDocumentCreateUsingUrl(CFURLRef theURL, NSString *password)
{
	CGPDFDocumentRef thePDFDocRef  =  NULL; // CGPDFDocument

	if (theURL !=  NULL) // Check for non-NULL CFURLRef
	{
		thePDFDocRef  =  CGPDFDocumentCreateWithURL(theURL);

		if (thePDFDocRef !=  NULL) // Check for non-NULL CGPDFDocumentRef
		{
			if (CGPDFDocumentIsEncrypted(thePDFDocRef)  ==  TRUE) // Encrypted
			{
				// Try a blank password first, per Apple's Quartz PDF example

				if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, "")  ==  FALSE)
				{
					// Nope, now let's try the provided password to unlock the PDF

					if ((password !=  nil) && (password.length > 0)) // Not blank?
					{
						char text[128]; // char array buffer for the string conversion

						[password getCString:text maxLength:126 encoding:NSUTF8StringEncoding];

						if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, text)  ==  FALSE) // Log failure
						{
							#ifdef DEBUG
								NSLog(@"CGPDFDocumentCreateUsingUrl: Unable to unlock [%@] with [%@]", theURL, password);
							#endif
						}
					}
				}

				if (CGPDFDocumentIsUnlocked(thePDFDocRef)  ==  FALSE) // Cleanup unlock failure
				{
					CGPDFDocumentRelease(thePDFDocRef), thePDFDocRef  =  NULL;
				}
			}
		}
	}
	else // Log an error diagnostic
	{
		#ifdef DEBUG
			NSLog(@"CGPDFDocumentCreateUsingUrl: theURL  ==  NULL");
		#endif
	}

	return thePDFDocRef;
}

//
//	CGPDFDocumentRef CGPDFDocumentCreateUsingData(CGDataProviderRef, NSString *) function
//

CGPDFDocumentRef CGPDFDocumentCreateUsingData(CGDataProviderRef dataProvider, NSString *password)
{
	CGPDFDocumentRef thePDFDocRef  =  NULL; // CGPDFDocument

	if (dataProvider !=  NULL) // Check for non-NULL CGDataProviderRef
	{
		thePDFDocRef  =  CGPDFDocumentCreateWithProvider(dataProvider);

		if (thePDFDocRef !=  NULL) // Check for non-NULL CGPDFDocumentRef
		{
			if (CGPDFDocumentIsEncrypted(thePDFDocRef)  ==  TRUE) // Encrypted
			{
				// Try a blank password first, per Apple's Quartz PDF example

				if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, "")  ==  FALSE)
				{
					// Nope, now let's try the provided password to unlock the PDF

					if ((password !=  nil) && (password.length > 0)) // Not blank?
					{
						char text[128]; // char array buffer for the string conversion

						[password getCString:text maxLength:126 encoding:NSUTF8StringEncoding];

						if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, text)  ==  FALSE) // Log failure
						{
							#ifdef DEBUG
								NSLog(@"CGPDFDocumentCreateUsingData: Unable to unlock data with '%@'", password);
							#endif
						}
					}
				}

				if (CGPDFDocumentIsUnlocked(thePDFDocRef)  ==  FALSE) // Cleanup unlock failure
				{
					CGPDFDocumentRelease(thePDFDocRef), thePDFDocRef  =  NULL;
				}
			}
		}
	}
	else // Log an error diagnostic
	{
		#ifdef DEBUG
			NSLog(@"CGPDFDocumentCreateUsingData: theURL  ==  NULL");
		#endif
	}

	return thePDFDocRef;
}

//
//	BOOL CGPDFDocumentUrlNeedsPassword(CFURLRef, NSString *) function
//

BOOL CGPDFDocumentUrlNeedsPassword(CFURLRef theURL, NSString *password)
{
	BOOL needPassword  =  NO; // Default flag

	if (theURL !=  NULL) // Check for non-NULL CFURLRef
	{
		CGPDFDocumentRef thePDFDocRef  =  CGPDFDocumentCreateWithURL(theURL);

		if (thePDFDocRef !=  NULL) // Check for non-NULL CGPDFDocumentRef
		{
			if (CGPDFDocumentIsEncrypted(thePDFDocRef)  ==  TRUE) // Encrypted
			{
				// Try a blank password first, per Apple's Quartz PDF example

				if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, "")  ==  FALSE)
				{
					// Nope, now let's try the provided password to unlock the PDF

					if ((password !=  nil) && (password.length > 0)) // Not blank?
					{
						char text[128]; // char array buffer for the string conversion

						[password getCString:text maxLength:126 encoding:NSUTF8StringEncoding];

						if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, text)  ==  FALSE)
						{
							needPassword  =  YES;
						}
					}
					else
					{
						needPassword  =  YES;
					}
				}
			}

			CGPDFDocumentRelease(thePDFDocRef); // Cleanup CGPDFDocumentRef
		}
	}
	else // Log an error diagnostic
	{
		#ifdef DEBUG
			NSLog(@"CGPDFDocumentUrlNeedsPassword: theURL  ==  NULL");
		#endif
	}

	return needPassword;
}

//
//	BOOL CGPDFDocumentUrlNeedsPassword(CGDataProviderRef, NSString *) function
//

BOOL CGPDFDocumentDataNeedsPassword(CGDataProviderRef dataProvider, NSString *password)
{
	BOOL needPassword  =  NO; // Default flag

	if (dataProvider !=  NULL) // Check for non-NULL CGDataProviderRef
	{
		CGPDFDocumentRef thePDFDocRef  =  CGPDFDocumentCreateWithProvider(dataProvider);

		if (thePDFDocRef !=  NULL) // Check for non-NULL CGPDFDocumentRef
		{
			if (CGPDFDocumentIsEncrypted(thePDFDocRef)  ==  TRUE) // Encrypted
			{
				// Try a blank password first, per Apple's Quartz PDF example

				if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, "")  ==  FALSE)
				{
					// Nope, now let's try the provided password to unlock the PDF

					if ((password !=  nil) && (password.length > 0)) // Not blank?
					{
						char text[128]; // char array buffer for the string conversion

						[password getCString:text maxLength:126 encoding:NSUTF8StringEncoding];

						if (CGPDFDocumentUnlockWithPassword(thePDFDocRef, text)  ==  FALSE)
						{
							needPassword  =  YES;
						}
					}
					else
					{
						needPassword  =  YES;
					}
				}
			}

			CGPDFDocumentRelease(thePDFDocRef); // Cleanup CGPDFDocumentRef
		}
	}
	else // Log an error diagnostic
	{
		#ifdef DEBUG
			NSLog(@"CGPDFDocumentUrlNeedsPassword: theURL  ==  NULL");
		#endif
	}

	return needPassword;
}

// EOF
