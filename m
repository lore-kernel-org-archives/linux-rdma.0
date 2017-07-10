From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rfc] RDMA: unite max_mr_page_list_len for FRWR and FMRs
Date: Mon, 10 Jul 2017 17:26:43 +0300
Message-ID: <1dbe09f5-9292-8ff0-9193-793032182f61@grimberg.me>
References: <1499691002-5224-1-git-send-email-sagi@grimberg.me>
 <3F7C141B-7CD5-44FB-A16E-E4D3D531CF23@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F7C141B-7CD5-44FB-A16E-E4D3D531CF23-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I thought the FMR page list limit was always 64. I seem to
> vaguely recall testing this way back when I split out the
> xprtrdma code for handling different registration modes,
> and above 64, FMR fell over (at least with CX2 and CX3).

Not sure about CX2, but iser runs fmrs with 128 entries perfectly fine
on CX3. IIRC CX2 does not support FRWRs, CX4 and up does not support
FMRs (which I'd love to kill altogether anyways).

The motivation is to not guess empirically what is the max page_list
for FMRs which is supposed to be on its way out anyhow.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
