From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] Revert "IB/core: Add flow control to the portmapper netlink calls"
Date: Wed, 31 May 2017 13:34:09 -0500
Message-ID: <03f901d2da3c$7e0f23a0$7a2d6ae0$@opengridcomputing.com>
References: <20170529082423.1180-1-leon@kernel.org> <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com> <20170531040437.GE5406@mtr-leonro.local> <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com> <03c501d2da35$d10a22f0$731e68d0$@opengridcomputing.com> <20170531182050.GL5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531182050.GL5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Mustafa Ismail' <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Hey Leon,
> >
> > I would hate to introduce an iwarp regression vs solving your issue w/o
> > reverting.  If I recall, the flow control is need so as to not drop messages
> > flowing from the kernel to the iwpmd.  I'm not sure how that could be fixed
in
> > the user daemon?
> 
> Assume that netlink is unreliable and set socket timeout.
> 
> Thanks

It seems that netlink is becoming more and more a message API between kernel and
user.  Wouldn't everyone benefit from make it reliable?  And I think we can
certainly provide blocking/reliable mode as an option to be used only by those
subsystems that require it.  

Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
