From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] mlx4: Protocol distinction
Date: Thu, 2 Dec 2010 09:26:56 +0200
Message-ID: <4CF74A40.5000608@voltaire.com>
References: <4CF67444.4080001@senin.name>	<AANLkTinwpuUis2Xj_U3PNSmZcM3LFr+A9V3JXanvH2Jr@mail.gmail.com> <AANLkTikBwo5sOo0-uDz28o_eqqMk4t=ME-TxeLZzO0+F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikBwo5sOo0-uDz28o_eqqMk4t=ME-TxeLZzO0+F-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/2/2010 8:53 AM, Aleksey Senin wrote:
> I don't think that this specific change should check firmware version,
> because it not dealing with hardware directly and it should work with
> older firmware too.

So the modified code works with older firmware, good news, Yevgeny, does 
this apply also to UC/MC steering patches which Tziporet mentioned recently?

> Its restriction, that now it will support 2^30 members for QP instead of 2^32.

I don't understand what "members for QP" means. And anyway, I don't 
think there's something in the HCA which can be allocated in the order 
of Gigs (billions, except maybe for bandwidth...) typically it goes up 
to Megs (millions). Also, as said here and elsewhere couple of times, 
bottom posting is very much easier and fun to work with for open-source 
development, if you want to learn a bit more on that, take a look @ 
http://www.caliburn.nl/topposting.html


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
