From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: get and print eeprom version
Date: Wed, 09 Jun 2010 13:38:56 -0700
Message-ID: <adatypckkkf.fsf@roland-alpha.cisco.com>
References: <20100609201953.GA2304@CTUNG-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609201953.GA2304@CTUNG-MOBL1> (Chien Tung's message of
	"Wed, 9 Jun 2010 15:19:53 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Is this something that it might be better to expose via ethtool in the
firmware-version field?  (You can have a string with multiple versions
of different components there, see eg get_drvinfo() in
drivers/net/cxgb3/cxgb3_main.c)

As far as I can see, in the current patch, you have eeprom_version as a
pure write-only field.  So instead of dumping to the kernel log, where
it might get lost and is in any case hard to find, make it easier to
read out when someone needs it.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
