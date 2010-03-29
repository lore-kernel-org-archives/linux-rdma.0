From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: fix dangling pointer references to ipoib_neigh and ipoib_path
Date: Mon, 29 Mar 2010 12:03:06 -0700
Message-ID: <adaeij3vtlh.fsf@roland-alpha.cisco.com>
References: <1267729108.3001.83.camel@chromite.mv.qlogic.com>
	<20100328160211.GA19300@mtldesk030.lab.mtl.com>
	<1269885823.4192.173.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1269885823.4192.173.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Mon, 29 Mar 2010 11:03:43 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > > @@ -249,44 +252,26 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
 > > >  			n = &pn->rb_left;
 > > >  		else if (ret > 0)
 > > >  			n = &pn->rb_right;
 > > > -		else
 > > > -			return -EEXIST;
 > > > +		else /* Should never happen since we always search first */
 > > > +			return;
 > > >  	}
 > > 
 > > Why not remove the last else and change the "else if" into else?
 > 
 > I don't understand. This is left, right, or return.
 > I'm only changing the return value to void since it is
 > never used.

It would probably be better to split that cleanup out into a separate
patch.  And since we have a "should never happen" condition in the code,
I guess we should either trust our code and just assume that it really
never happens (ie have just an if-else as Eli suggests), or add
something like a WARN_ONCE() if it actually does happen (probably safer)
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
