From: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: livelock in
 pr_rcv_get_path_parms
Date: Wed, 21 Apr 2010 12:40:25 +0200
Message-ID: <4BCED619.6040000@Sun.COM>
References: <4BCC1F3F.5080000@Sun.COM> <20100419153421.GB23994@me>
 <4BCCA1C5.5000904@Sun.COM> <20100421102112.GE23994@me>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20100421102112.GE23994@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/21/10 12:21 PM, Sasha Khapyorsky wrote:
> On 20:32 Mon 19 Apr     , Line Holen wrote:
>> The value of 128 was chosen as 2x max DR path allowing the SM to be in
>> the middle of a fabric. But I have no problem lowering to 64.
> 
> Would you care about patch?

Sure, I can send a patch.

Line

> 
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
