From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 20 Jun 2013 13:48:38 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6939C5@xmb-rcd-x01.cisco.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com>
 <20130618184928.GE2204@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130618184928.GE2204-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <112857EE15E43B468CBD4CF50CE5EFEE-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 18, 2013, at 2:49 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

>> +int num_to_ibv_mtu(int num);
> 
> Probably should be ibv_num_to_mtu() to keep with the naming pattern..


New patch coming momentarily, but I wanted to comment on this one: 

I used the name "num_to_ibv_mtu" because it is in the spirit of the other enum-to-int/int-to-enum function pair naming conventions:

int ibv_rate_to_mult(enum ibv_rate rate);
enum ibv_rate mult_to_ibv_rate(int mult);

int ibv_rate_to_mbps(enum ibv_rate rate);
enum ibv_rate mbps_to_ibv_rate(int mbps);

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
