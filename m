From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics
 on one opensm server
Date: Fri, 02 Mar 2012 10:47:10 -0500
Message-ID: <4F50EB7E.20900@redhat.com>
References: <4F4DB11C.5080203@redhat.com> <20120229112229.136f25b7.weiny2@llnl.gov> <20120302103015.GB6644@calypso> <4F50E7CE.6050204@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0AFD245AA62CCEFE19F35707"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F50E7CE.6050204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0AFD245AA62CCEFE19F35707
Content-Type: multipart/mixed;
 boundary="------------080709050107050501060505"

This is a multi-part message in MIME format.
--------------080709050107050501060505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 3/2/2012 10:31 AM, Doug Ledford wrote:
> On 3/2/2012 5:30 AM, Alex Netes wrote:
>> What the default opensm.conf would be used for? Just as a reference to=
 the
>> default values?
>=20
> No, he's referring to having a default config file that is parsed, then=

> an override config file that is parsed where you only put options you
> want to update in the override config file.  That way you could have,
> for instance, a default opensm.conf in the normal location and totally
> unedited so that it gets updated with each update of the opensm rpm,
> then you could create an opensm.conf.1 that is empty except for just a
> guid setting, a subnet_prefix setting, maybe a cache dir setting, etc.
> In that way, if say the default routing engine gets a new option in the=

> future, your override config file won't already be populated with the
> old stuff.  It's a means of inheritance that is functionally identical
> to specifying all this stuff on the command line, but doesn't require a=

> huge command line or a complex init script.

And for what it's worth, it could be as simply done as the attached
(untested, but compiled) patch.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------080709050107050501060505
Content-Type: text/plain;
 name="opensm-config.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="opensm-config.patch"

diff -up opensm-3.3.13/opensm/main.c.config opensm-3.3.13/opensm/main.c
--- opensm-3.3.13/opensm/main.c.config	2012-03-02 10:35:26.783996345 -050=
0
+++ opensm-3.3.13/opensm/main.c	2012-03-02 10:46:33.471939369 -0500
@@ -131,6 +131,13 @@ static void show_usage(void)
 	       "          The name of the OpenSM config file. When not specifie=
d\n"
 	       "          " OSM_DEFAULT_CONFIG_FILE
 	       " will be used (if exists).\n\n");
+	printf("--extra-config, -E <file-name>\n"
+	       "          The name of an OpenSM config file used to over ride\n=
"
+	       "          the entries in the primary config file.  This is\n"
+	       "          useful when you have more than one opensm instance\n"=

+	       "          to manage and you want them all to have a central,\n"=

+	       "          shared set of options and you want a second, smaller\=
n"
+	       "          config file to hold their fabric specific options.\n\=
n");
 	printf("--create-config, -c <file-name>\n"
 	       "          OpenSM will dump its configuration to the specified f=
ile and exit.\n"
 	       "          This is a way to generate OpenSM configuration file t=
emplate.\n\n");
@@ -569,10 +576,10 @@ int main(int argc, char *argv[])
 	boolean_t run_once_flag =3D FALSE;
 	int32_t vendor_debug =3D 0;
 	int next_option;
-	char *conf_template =3D NULL, *config_file =3D NULL;
+	char *conf_template, *config_file, *extra_config_file;
 	uint32_t val;
 	const char *const short_option =3D
-	    "F:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:q:=
k:C:G:H:";
+	    "F:E:c:i:w:O:f:ed:D:g:l:L:s:t:a:u:m:X:R:zM:U:S:P:Y:ANBIQvVhoryxp:n:=
q:k:C:G:H:";
=20
 	/*
 	   In the array below, the 2nd parameter specifies the number
@@ -584,6 +591,7 @@ int main(int argc, char *argv[])
 	const struct option long_option[] =3D {
 		{"version", 0, NULL, 12},
 		{"config", 1, NULL, 'F'},
+		{"extra-config", 1, NULL, 'E'},
 		{"create-config", 1, NULL, 'c'},
 		{"debug", 1, NULL, 'd'},
 		{"guid", 1, NULL, 'g'},
@@ -647,6 +655,7 @@ int main(int argc, char *argv[])
 		{"torus_config", 1, NULL, 10},
 		{NULL, 0, NULL, 0}	/* Required at the end of the array */
 	};
+	conf_template =3D config_file =3D extra_config_file =3D NULL;
=20
 	/* force stdout to be line-buffered */
 	setvbuf(stdout, NULL, _IOLBF, BUFSIZ);
@@ -672,6 +681,11 @@ int main(int argc, char *argv[])
 			config_file =3D optarg;
 			printf("Config file is `%s`:\n", config_file);
 			break;
+		case 'E':
+			extra_config_file =3D optarg;
+			printf("Extra Config file is `%s`:\n",
+			       extra_config_file);
+			break;
 		default:
 			break;
 		}
@@ -687,6 +701,11 @@ int main(int argc, char *argv[])
 	if (osm_subn_parse_conf_file(config_file, &opt) < 0)
 		printf("\nFail to parse config file \'%s\'\n", config_file);
=20
+	if (extra_config_file)
+		if (osm_subn_parse_conf_file(extra_config_file, &opt) < 0)
+			printf("\nFailed to parse extra config file `%s`\n",
+			       extra_config_file);
+
 	printf("Command Line Arguments:\n");
 	do {
 		next_option =3D getopt_long_only(argc, argv, short_option,

--------------080709050107050501060505--

--------------enig0AFD245AA62CCEFE19F35707
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPUOt/AAoJELgmozMOVy/dANIQAKA7lAMn9DKo7BGKwxkJeIce
xEuXVlGqrLHSZu40d12O4GVoFSihxU5RwDBVfqUw3aj6tlL2m9rjZuSIeSjo5f0w
lyeEUitHIFj7iIF1KfwCrKyryxqkdg79BMfIsxHqv2L7MnUUhmKGnpoVyxd5/IMK
UKMFXb4Ae1N4rJEDhqg4iAe+Qss9/A43b+kLGSiIcfa755GtzlIFzoB9AFuhQl4z
gWI+nMc5ezlINSC4MG7xlpoVRaaHdBtXs9J5yXEjo3aIWiHMhS6tURCd+Qx3IqmU
hbROjx1XDGOfWlAdob9MkGpJCB/JuMFW/2whOSpyZb3UsAmGqaXLXflEAviGGQhQ
zjgOQlVkP50uIok4vjPC5vBg13/h7EGJUfl6uP5qKzW483qw5XhZ3vMRoLy2BQ20
9rXGK78PtTcgQ8AjZsxaBxTRU+VSzdsAXxh94d1bt2sKBD9omQ+WGx/0738jZJ8k
BefeKa/RZqplw3fyVcUh4HkNzKzlk40M3z+mrRIMCF3lVjz4kfG+LWNZcymNZg7w
EM28J1JklC7/+d4oFNuO+Dguhc3CgiDJvhokibf3VbuG54c8lyOkee9DZxjon1aE
a/aekteiNWSWUXEcljec8SBoAUkIxtRAIT1SOSRJl7lF93TuKtkvGsYeKDFaECNt
v7NTQoSytmSJ0NJpihyX
=Kcnq
-----END PGP SIGNATURE-----

--------------enig0AFD245AA62CCEFE19F35707--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
