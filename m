From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 2/7] libibverbs: Introduce XRC domains
Date: Sun, 17 Mar 2013 15:47:18 +0200
Message-ID: <5145C966.2010801@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981A0@FMSMSX151.amr.corp.intel.com> <1363394326-908-2-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363394326-908-2-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I don't see cover-letter for V4 of libibverbs and V3 of libmlx4 patches 
you posted over the weekend, would be nice if you
can reply to one of your posting per series and send quick listing of 
the changes (if any) from previous versions.

Or.

Also a little nit... I think there's no need to have the library 
**name**  as part of the actual commit but rather
as part of the text in the brackets which is later dropped when applied 
into git.

e.g

[PATCH v3 1/2] libmlx4:  Infra-structure changes to support verbs extensions

needs to be

[PATCH libmlx4 v3 1/2] Infra-structure changes to support verbs extensions

and so on which you can do easily through git format-patch 
--subject-prefix="PATCH libmlx4 v3" etc


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
