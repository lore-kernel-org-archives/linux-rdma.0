From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Problem running rping over Intel adapters
Date: Wed, 03 Oct 2012 17:40:57 -0400
Message-ID: <506CB0E9.90201@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF9271AFD288F91FB19DE224"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF9271AFD288F91FB19DE224
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We ran into this problem when testing rping over Intel/QLogic hardware:

[root@rdmaperf3 ~]# rping -s -a 172.31.2.103 -v
wait for CONNECTED state 10
connect error -1
cma event RDMA_CM_EVENT_REJECTED, error 28
[root@rdmaperf3 ~]#


[root@rdmaperf8 ~]# rping -c -a 172.31.2.103 -v -C 5
cma event RDMA_CM_EVENT_CONNECT_ERROR, error -1
wait for CONNECTED state 4
connect error -1
[root@rdmaperf8 ~]#

Turns out this is because of a couple things:

1) rping, on the client side, clears the conn_params for the newly to be
attempted connection, then sets:

	conn_param.responder_resources =3D 1;
	conn_param.initiator_depth =3D 1;
	conn_param.retry_count =3D 10;

On the accept side, rping clears the conn_params and then sets just the
responder_resources and initiator_depth, without even checking the
incoming requested conn_param values from the incoming cm_id.  So, OK,
you can get away with that since this is a simple test program, but
still not "best programming practices".  However, the important part
here is the retry_count of 10.  That won't work on Intel/QLogic hardware.=


2) the qib driver enforces a maximum of 7 for retry_count.  I don't see
anything in the spec that specifies a maximum for this entry, and in
particular I know it doesn't call out for 7 to mean infinite retries
like it does for rnr_retry_count.

I don't think the spec really cares how we solve this, and I don't think
there is a hard limit of 7 for the retry_count like the qib driver
enforces.  On the other hand, the spec doesn't call out a limit on the
retry_count but I would assume each driver has the option to implement
their own "reasonable, implementation defined" limit in a case like this.=


So, do we make qib more liberal in its acceptance of retry_count or do
we fix rping to use a smaller number?  Matters not to me...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEF9271AFD288F91FB19DE224
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQbLDvAAoJELgmozMOVy/dWJgQAL+XYSL8VNiJHAI9fNnGacx7
VVxl7N5IhornjtmgdQFUMjzwJjlWX/WLer6/nowqeVXkDLMOf6WfkHE3yp2hR/hW
fbSIPncQJAhzYcXhf7ZT8GC8d2W44vzdyBogLJmUKUfC5mdSsGrfCgqOEDAaRb93
XEywcrNbDdDhoRP4Gb+rtQjcCiaLEE+xAotlYYr0qBcjRwRKZbYDU6Cbc0VVFhW/
pq6g1lf85rG12bYdMLKpgmo2RXNbniQfzziTtNr6KbD94dvhC21L7C1oHh2OGnaX
hz4aGRgzngN3cU3YScgJ1gIsXbPmm2vBLctdpNPOKE6AsXwtJAMuFIHmeNg+lfb1
SlASkqA4PZmPDE8oPPqUeyRhgZoc0bMRtf/ppaLVUsVYQUgJT2Hbk8bcABmqqUgf
7Nt64Cxn7ogTHoF5Ympw9N4chOjqMaHFSir7JcpD9RyWZ+ftJ7qxC7YSf0FMsEy2
9wkQstSk7PHTvwJDyy8YYdfEeECKkfiBkRk+sdzckeR1cmDuDWmTX2QRZeph18wL
1ettf/yoL/wMS0cYcPIjheceAOzcjcwsk9nK+38akYhWG1mPZhvYc+8H/DgQeEm5
wSp5NdUEn9L0onzlKKskcKFzMTMlACImyT5vDQh92lS1IxzH/BfsYU9E0WkYOX8Q
cWRyBmJVS9JesTM3tgnB
=EgBo
-----END PGP SIGNATURE-----

--------------enigEF9271AFD288F91FB19DE224--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
