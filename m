From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: WRITE/SEND to multiple destinations
Date: Mon, 3 Nov 2014 15:50:55 -0500
Message-ID: <CADPSxAhwDX6=B4hB_21otZeSqvtgNvFXT5CfFatfRdO-dTDAeQ@mail.gmail.com>
References: <loom.20141103T000730-108@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20141103T000730-108-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

You can do SEND/RECV over Unreliable Datagram multicast which could be
beneficial in your situation (i.e., better than 1-1 connections). You
can't use multicast for READs or WRITEs.

--Anuj

On Sun, Nov 2, 2014 at 9:32 PM, floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hello everyone,
>
> As a newbie to the world of InfiniBand programming,
> I would appreciate your helps on my somewhat general and basic question.
>
> Assume that I have a server, and N clients (N > 1).
> I would like my server to set all clients' memory buffers to some value V.
> How would I go about this problem?
> So far, I've managed to establish 1-1  connections using READ/WRITE/SEND/RECEIVE.
> So I guess the core of my question is:
> how 1-to-N  connections are established in InfiniBand, and
> if, in this regard, there is any difference between
> RDMA verbs (READ/WRITE) vs. SEND/RECEIVE?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
