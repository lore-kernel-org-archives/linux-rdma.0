From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: srp warning
Date: Wed, 12 Jan 2011 11:50:23 -0800
Message-ID: <adak4i952bk.fsf@cisco.com>
References: <adalj2q587i.fsf@cisco.com>
	<1294854748.15826.26.camel@lap75545.ornl.gov>
	<ada8vyq57bq.fsf@cisco.com>
	<1294861341.15826.38.camel@lap75545.ornl.gov>
	<adaoc7l52hy.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaoc7l52hy.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Roland Dreier's message of "Wed, 12
	Jan 2011 11:46:33 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Attached -- I'm using kind of a minimal config for build testing, so
 > maybe I have some strange optimization enabled (CONFIG_CC_OPTIMIZE_FOR_SIZE=y?)

Indeed... unsetting CONFIG_CC_OPTIMIZE_FOR_SIZE seems to get rid of the warning.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
