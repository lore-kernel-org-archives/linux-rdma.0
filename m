From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Subject: Re: QOS setup issue with opensm
Date: Tue, 24 Nov 2009 15:35:49 +0100
Message-ID: <4B0BEF45.9020404@bull.net>
References: <4B0BA0EC.3050202@bull.net> <4B0BAF21.1020401@dev.mellanox.co.il> <4B0BB79F.9080806@bull.net> <4B0BC0CC.4050409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0BC0CC.4050409-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Yevgeny,

> I don't know what exactly are you trying to do,
> so I don't know which option is the correct one.
> If you just want to have default IPoIB to use
> SL4, you can use the first option:
>
>     qos-ulps
>         default          : 0 # default SL
>         ipoib            : 4 # TCP tests over IB
>     end-qos-ulps
>
> As you already noted, you will see the error message
> about SL mismatch in the OSM log. The reason for this
> is default partition configuration: if no partition
> file was provided, SM defines default IPoIB partition
> with default pkey, which is 0x7fff, and other default
> parameters, one of them is SL0.
> So you get the SL mismatch again, but SM uses what you
> provided in the QoS policy as an SL with higher precedence
> and replaces the SL0 in the partition.
>
OK, this makes sense. I carried out some tests and it did work.

Thanks for your help,

Vincent
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
