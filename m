From: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH perftest v2] Bug fix write latency
Date: Sun, 5 Mar 2017 15:39:39 +0000
Message-ID: <AM5PR0501MB253232900CECAD35B2E47E3BA92D0@AM5PR0501MB2532.eurprd05.prod.outlook.com>
References: <1488727361-23364-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488727361-23364-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Ram for the quick response!!!
it will be pushed to main branch within a few days.
Do you familiar with Perftest Git-hub repository ? =20
	https://github.com/linux-rdma/perftest
you can use it to push patches as well.=20


Thanks ,=20

Zohar Ben Aharon





-----Original Message-----
From: Ram Amrani [mailto:Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org]=20
Sent: Sunday, March 05, 2017 5:23 PM
To: Zohar Ben Aharon <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Ra=
m Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH perftest v2] Bug fix write latency

Avoid setting the value '1' in the MR. If this does happen then the server =
will send two consecutive packets, regardless of the client's state. This c=
an cause the application to hang. If the client reaches the busy-wait loop =
after the second write then it'll hang in the loop forever, waiting for the=
 value of the first write.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 src/perftest_resources.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/perftest_resources.c b/src/perftest_resources.c index afae=
5f2..21ff972 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -1252,7 +1252,11 @@ int create_single_mr(struct pingpong_context *ctx, s=
truct perftest_parameters *u
 	/* Initialize buffer with random numbers */
 	srand(time(NULL));
 	for (i =3D 0; i < ctx->buff_size; i++) {
-		((char*)ctx->buf[qp_index])[i] =3D (char)rand();
+		/* prevent the value 1 from being written into the buffer so in,
+		 * e.g., write latency test, the server won't send two packets
+		 * consecutively without receiving a packet from the client first.
+		 */=20
+		((char*)ctx->buf[qp_index])[i] =3D 2 + ((unsigned char)rand() % 255);
 	}
=20
 	return 0;
--
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
