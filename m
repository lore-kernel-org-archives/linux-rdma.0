From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] librdmacm: Use common prefix for error messages
Date: Sun, 26 Aug 2012 12:07:20 +0200
Message-ID: <1345975640.1656.17.camel@test.quest-ce.net>
References: <1345899810-1615-1-git-send-email-ydroneaud@opteya.com>
	 <1345899810-1615-2-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345899810-1615-2-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry for the scarce description of this patch:

libibverb is using a prefix for all messages, and like libibverbs,
librdmacm has a #define PFX, but did not use it.

This patch use the prefix for all errors messages issued by librdmacm.

Regards.

-- 
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
