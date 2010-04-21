From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] support diffing lids and nodedesc on
	remoteports in ibnetdiscover
Date: Wed, 21 Apr 2010 11:19:44 -0700
Message-ID: <1271873984.17987.244.camel@auk31.llnl.gov>
References: <1271802640.17987.230.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XYhApFuMKIs3iHqzpgO3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1271802640.17987.230.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-XYhApFuMKIs3iHqzpgO3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

A slight tweak to the patch.  Support diffing lids and node descriptions
on remote ports (previously it diffed only "local" lids and node
descriptions).  Also add appropriate manpage notes.

Al

On Tue, 2010-04-20 at 15:30 -0700, Al Chu wrote:
> Hey Sasha,
> 
> This patch supports diffing node descriptions on remote ports
> (previously diffing of just the "local" node description was supported).
> 
> Al
> 
> email message attachment
> > -------- Forwarded Message --------
> > From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > Subject: [PATCH] support diffing nodedesc on remoteports in
> > ibnetdiscover
> > Date: Tue, 20 Apr 2010 15:09:59 -0700
> > 
> > Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  infiniband-diags/src/ibnetdiscover.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
> > index 57f9625..eeb1b9f 100644
> > --- a/infiniband-diags/src/ibnetdiscover.c
> > +++ b/infiniband-diags/src/ibnetdiscover.c
> > @@ -720,6 +720,17 @@ static void diff_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
> >  			fabric2_out++;
> >  		}
> >  
> > +		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
> > +		    && data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
> > +		    && fabric1_port && fabric2_port
> > +		    && fabric1_port->remoteport && fabric2_port->remoteport
> > +		    && memcmp(fabric1_port->remoteport->node->nodedesc,
> > +			      fabric2_port->remoteport->node->nodedesc,
> > +			      IB_SMP_DATA_SIZE)) {
> > +			fabric1_out++;
> > +			fabric2_out++;
> > +		}
> > +
> >  		if (fabric1_out) {
> >  			diff_iter_out_header(fabric1_node, data,
> >  					     out_header_flag);
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-XYhApFuMKIs3iHqzpgO3
Content-Disposition: attachment; filename*0=0001-support-diffing-lids-and-nodedesc-on-remoteports-in.patc; filename*1=h
Content-Type: message/rfc822; name=0001-support-diffing-lids-and-nodedesc-on-remoteports-in.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 20 Apr 2010 15:09:59 -0700
Subject: [PATCH] support diffing lids and nodedesc on remoteports in
	ibnetdiscover
Message-Id: <1271873984.17987.245.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibnetdiscover.8 |    5 ++++-
 infiniband-diags/src/ibnetdiscover.c |   20 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/man/ibnetdiscover.8 b/infiniband-diags/man/ibnetdiscover.8
index 76cfbc8..3beb70b 100644
--- a/infiniband-diags/man/ibnetdiscover.8
+++ b/infiniband-diags/man/ibnetdiscover.8
@@ -71,7 +71,10 @@ are: \fIsw\fR = switches, \fIca\fR = channel adapters, \fIrouter\fR = routers,
 \fIport\fR = port connections, \fIlid\fR = lids, \fInodedesc\fR = node
 descriptions.  Note that \fIport\fR, \fIlid\fR, and \fInodedesc\fR are
 checked only for the node types that are specified (e.g. \fIsw\fR,
-\fIca\fR, \fIrouter\fR).
+\fIca\fR, \fIrouter\fR).  If \fIport\fR is specified alongside \fIlid\fR
+or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
+
+
 .TP
 \fB\-p\fR, \fB\-\-ports\fR
 Obtain a ports report which is a
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 57f9625..23e6dd4 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -720,6 +720,26 @@ static void diff_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 			fabric2_out++;
 		}
 
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    && data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
+		    && fabric1_port && fabric2_port
+		    && fabric1_port->remoteport && fabric2_port->remoteport
+		    && memcmp(fabric1_port->remoteport->node->nodedesc,
+			      fabric2_port->remoteport->node->nodedesc,
+			      IB_SMP_DATA_SIZE)) {
+			fabric1_out++;
+			fabric2_out++;
+		}
+
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    && data->diff_flags & DIFF_FLAG_LID
+		    && fabric1_port && fabric2_port
+		    && fabric1_port->remoteport && fabric2_port->remoteport
+		    && fabric1_port->remoteport->base_lid != fabric2_port->remoteport->base_lid) {
+			fabric1_out++;
+			fabric2_out++;
+		}
+
 		if (fabric1_out) {
 			diff_iter_out_header(fabric1_node, data,
 					     out_header_flag);
-- 
1.5.4.5


--=-XYhApFuMKIs3iHqzpgO3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
