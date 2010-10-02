From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: gratuitous arps lost during IB switch failure
Date: Sat, 2 Oct 2010 22:17:56 +0200
Message-ID: <AANLkTinwGJq-aRM43ct9_1PrUCkn7QMecPczPpEyD2pQ@mail.gmail.com>
References: <4C9942F3.5090206@oracle.com>
	<loom.20101001T010729-594@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20101001T010729-594-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sumeet <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> It turns out that this problem was being caused because we had multiple IPs
> configured on the bonded infiniband interface. It appears that grat. arps are
> being sent out for only one of those IPs. [...]  Can the bonding
> driver be fixed to send out grat arps for both these IPs?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
