using ImageMagick;
Console.WriteLine("Beginning test..");

using var image = new MagickImage("./Images/test.tiff");

// Can reproduce with and without setting a font
//image.Settings.Font = "Ariel";
image.Settings.FontPointsize = 36; // Make it a little easier to spot on the image
image.Annotate("Hello world", Gravity.North); // Missing fonts on my ubuntu VM

var tiffBytes = image.ToByteArray();

image.Write(@"temp.tiff");

Console.WriteLine("Finished processing image temp.tiff");
