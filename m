From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] add RAW Packet QP type
Date: Tue, 21 May 2013 22:57:18 +0300
Message-ID: <CAJZOPZJxwLVDova19nr9yJJ5v20cc+5Cu6uMjdOvHiR3+aX3og@mail.gmail.com>
References: <alpine.LRH.2.00.1201171330540.24946@ogerlitz.voltaire.com>
	<4F158ED7.3080405@opengridcomputing.com>
	<4F159AEB.1060603@mellanox.com>
	<4F15A008.9010303@opengridcomputing.com>
	<20130520224308.GA16639@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130520224308.GA16639-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Felix Marti <felix-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 21, 2013 at 1:43 AM, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I appologize if I missed it, but did any support for L3/L4 CSUM
> generation get added?  Doesn't look like the upstream libibverbs has
> it, and I don't seem to see any patches floating around.

Roland commented that he will make a point release  this week for
libibverbs and libmlx4, the patches for CSUM offload I will post after
that release.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
