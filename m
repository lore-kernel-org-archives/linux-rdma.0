From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] Further timeout paramater verification (Was: [PATCH]
 infiniband-diags: Verify timeout value specified to diagnostics)
Date: Wed, 22 Dec 2010 11:47:07 -0800
Message-ID: <20101222114707.c6ec051f.weiny2@llnl.gov>
References: <20101220215735.GA4020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101220215735.GA4020-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 20 Dec 2010 13:57:36 -0800
Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Sorry if you get this more than once, I seem to have outgoing mail misconfiguration here.
> 
> On Wed, Dec 15, 2010 at 11:47:09AM -0800, Ira Weiny wrote:
> >
> > Verify timeout value specified to diagnostics
> >
> >
> > Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> > ---
> >  infiniband-diags/src/ibdiag_common.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-diags/src/ibdia
> +g_common.c
> > index 99861f1..8ccf2fc 100644
> > --- a/infiniband-diags/src/ibdiag_common.c
> > +++ b/infiniband-diags/src/ibdiag_common.c
> > @@ -175,9 +175,13 @@ static int process_opt(int ch, char *optarg)
> >               ibd_dest_type = IB_DEST_GUID;
> >               break;
> >       case 't':
> > -             val = strtoul(optarg, 0, 0);
> > -             madrpc_set_timeout(val);
> > -             ibd_timeout = val;
> > +             val = (int)strtol(optarg, NULL, 0);
> > +             if (val > 0) {
> > +                     madrpc_set_timeout(val);
> > +                     ibd_timeout = val;
> > +             } else
> > +                     IBERROR("Invalid timeout \"%s\".  Timeout requires a "
> > +                             "positive integer value.", optarg);
> >               break;
> >       case 's':
> >               /* srcport is not required when resolving via IB_DEST_LID */
> > --
> > 1.5.4.5
> 
> This only partially detects invalid timeouts.  For example, timeouts
> of "123skidoo" or 1234534587347895789457897897894578978912902393 will
> be accepted but will not work as expected.  To fully test the
> conversion, you need to do something more like:
> 
>   long val;
>   char *endp;
> 
>   ...
>   errno = 0;
>   val = strtol ( optarg, &endp 0 );
>   if ( errno || ( endp && *endp != '\0' ) || val < 0 || val > INT_MAX ) {
>         /* invalid timeout detected */
>   ...
> 
> All of the tests are required to detect invalid inputs.
> 
> 		-- JF


Patch below,
Ira


From: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
Date: Wed, 22 Dec 2010 11:40:33 -0800
Subject: [PATCH] Further timeout paramater verification

suggested by Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
---
 infiniband-diags/src/ibdiag_common.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-diags/src/ibdiag_common.c
index 8ccf2fc..8f5eec3 100644
--- a/infiniband-diags/src/ibdiag_common.c
+++ b/infiniband-diags/src/ibdiag_common.c
@@ -138,7 +138,8 @@ void ibdiag_show_usage()
 
 static int process_opt(int ch, char *optarg)
 {
-	int val;
+	char *endp;
+	long val;
 
 	switch (ch) {
 	case 'h':
@@ -175,13 +176,16 @@ static int process_opt(int ch, char *optarg)
 		ibd_dest_type = IB_DEST_GUID;
 		break;
 	case 't':
-		val = (int)strtol(optarg, NULL, 0);
-		if (val > 0) {
-			madrpc_set_timeout(val);
-			ibd_timeout = val;
-		} else
+		errno = 0;
+		val = strtol(optarg, &endp, 0);
+		if (errno || (endp && *endp != '\0') || val <= 0 ||
+		    val > INT_MAX)
 			IBERROR("Invalid timeout \"%s\".  Timeout requires a "
-				"positive integer value.", optarg);
+				"positive integer value < %d.", optarg, INT_MAX);
+		else {
+			madrpc_set_timeout((int)val);
+			ibd_timeout = (int)val;
+		}
 		break;
 	case 's':
 		/* srcport is not required when resolving via IB_DEST_LID */
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
