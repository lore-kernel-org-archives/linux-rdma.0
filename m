From: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: sdp and port 0
Date: Tue, 25 May 2010 11:34:18 +0300
Message-ID: <4BFB8B8A.6080205@mellanox.co.il>
References: <1274178031.6513.22.camel@spike.ugent.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274178031.6513.22.camel-qUgQvq5LSkOu2fxVTW3+XQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stijn De Weirdt <stijn.deweirdt-Cru1EgDzd7c@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Stijn Hi,

Listening to port 0 is supported and should work.
Which OFED version do you use (issue ofed_info to know)?

Does it work for you on a simple test application that only listen on a socket?

- Amir


On 05/18/2010 01:20 PM, Stijn De Weirdt wrote:
> hi all,
>
> (i'm not on the list, please keep me in cc)
>
> i am trying SDP with some executable (i don't have the source), but i'm
> getting errors with the bind step (output from strace):
>
> bind(20, {sa_family=AF_INET, sin_port=htons(0),
> sin_addr=inet_addr("1.2.3.4")}, 16) = -1 EADDRINUSE (Address already in
> use)
>
> is it possible that a bind to port 0 (ie ask system for free port) is
> not supported with libsdp?
>
> using 'both' as addressfamily in the configfile instead of 'sdp' works
> but the tcp is used.
> i also tried to add a portrange to avoid port 0 with sdp (ie tcp for
> port 0, sdp for the rest), but this doesn't work either (which is not
> that surprising).
>
>
> thanks a lot,
>
> stijn
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
