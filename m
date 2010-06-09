From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: get and print eeprom version
Date: Wed, 9 Jun 2010 14:19:21 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E90492468661@azsmsx506.amr.corp.intel.com>
References: <20100609201953.GA2304@CTUNG-MOBL1>
 <adatypckkkf.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatypckkkf.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is this something that it might be better to expose via ethtool in the
> firmware-version field?  (You can have a string with multiple versions
> of different components there, see eg get_drvinfo() in
> drivers/net/cxgb3/cxgb3_main.c)

The main purpose of the patch is to read the eeprom version number and
save it off for later use.  We will be using that field programmatically
in a later patch.  We can certainly expose it via ethtool but I would
prefer a separate eeprom-version field instead of overloading firmware-version.

> As far as I can see, in the current patch, you have eeprom_version as a
> pure write-only field.  So instead of dumping to the kernel log, where
> it might get lost and is in any case hard to find, make it easier to
> read out when someone needs it.

I typically grep for "iw_nes" when looking for nes prints.  It is convenient
to have version numbers printed instead of asking someone to explicitly run
another command.  If you feel strongly about it I can certainly take the
prints out.

Chien


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
