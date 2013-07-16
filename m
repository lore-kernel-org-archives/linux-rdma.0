From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 11/13] IB/srp: Make HCA completion vector configurable
Date: Tue, 16 Jul 2013 04:58:39 -0600
Message-ID: <51E5275F.2070009@acm.org>
References: <51D41C03.4020607@acm.org> <51D41FFC.6070105@acm.org> <51E272A4.5030707@mellanox.com> <51E3D79D.9070808@acm.org> <51E3F931.9080903@mellanox.com> <51E43E22.2060502@acm.org> <51E51C56.50906@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E51C56.50906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16/07/2013 4:11, Sagi Grimberg wrote:
> This sounds like a nice Idea, but there an inherent problem about
> applications coming and going while the connections are static (somewhat),
> how can you control pinning an arbitrary application running (over SRP
> devices of-course) at certain point of time.
>
> So will you agree at least to give target->comp_vector a default of
> IB_CQ_VECTOR_LEAST_ATTACHED?
>  From my point of view, a user that don't have a slightest clue about
> completion vectors and performance optimization, this is somewhat better
> than doing nothing...

Hello Sagi,

That sounds like an interesting proposal to me. But did the patch that 
adds the IB_CQ_VECTOR_LEAST_ATTACHED feature ever get accepted in the 
upstream Linux kernel ? I have tried to find that symbol in Linux kernel 
v3.11-rc1 but couldn't find it. Maybe I have overlooked something ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
