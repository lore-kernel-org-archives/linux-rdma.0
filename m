From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: add path record definitions to sa.h
Date: Thu, 06 May 2010 15:33:24 -0700
Message-ID: <adapr18zmmj.fsf@roland-alpha.cisco.com>
References: <2420730B531C4665BD842A7F46007DA2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2420730B531C4665BD842A7F46007DA2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Thu, 6 May 2010 15:22:58 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > +#define IB_PATH_RECORD_REVERSIBLE 0x80
 > +
 > +struct ib_path_record

Can we use IBV_ / ibv_ prefixes here to match the rest of libibverbs?
Also having struct ibv_sa_path_rec and struct ibv_path_record is sort of
unfortunate.  Not sure if I can think of a better name here though --
ibv_raw_path_record?  ibv_packed_path_record?  Oh well...
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
