From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: umad Problems
Date: Thu, 11 Aug 2011 09:24:46 -0700
Message-ID: <20110811092446.864e0f17.weiny2@llnl.gov>
References: <CAEWMEApqyRmhUvuXEUs69uZyC4LMbXetP17nZDD0kFLOn_Qzjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEWMEApqyRmhUvuXEUs69uZyC4LMbXetP17nZDD0kFLOn_Qzjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Pusch <pusch.david-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 11 Aug 2011 01:58:23 -0700
David Pusch <pusch.david-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:

> Hello,
> I'm working on setting up an Infiniband Configuration on 2 Servers,
> but even though I get opensm to start I can't do nothing, as it throws
> this error in the logs.
> 
> ug 11 09:02:15 298290 [7829F720] 0x01 -> osm_vendor_open_port: ERR
> 542C: umad_open_port() failed
> 
> Can anybody make anything of this?

Could it be a permissions issue with /dev/umadX?

Ira

> Thanks in advance
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
