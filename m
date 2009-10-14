From: Sergey Zhumatiy <serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org>
Subject: Re: [Fwd: FW: OFED installation question re-AltLinux]
Date: Wed, 14 Oct 2009 13:39:02 +0400
Message-ID: <4AD59C36.7000409@parallel.ru>
References: <4AD4ACBD.2000409@nasa.gov> <4AD4C281.6060009@sanger.ac.uk>
Reply-To: serg-bzQdu9zFT3Uox3rIn2DAYQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD4C281.6060009-5fLPn3lgkryFxr2TtlUqVg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Coates <gmpc-5fLPn3lgkryFxr2TtlUqVg@public.gmane.org>
Cc: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, Sujal Das <sujal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jeffrey Scott <jeff-PQF7zMLV7HqjP/IhtLckvQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> OFED debian packages (up to OFED 1.4.2) are available here:
> 
> http://pkg-ofed.alioth.debian.org/
> 
  Ok! Thank you very much! I'll try them.

  But main question is still open:  how to install OFED on AltLinux or
other distributive (not Fedora/Suse). Older installer simply did
compilation on any system... I can use switch to ignore dependencies,
but it cannot do uninstall older packages (I think it does incorrectly
detect dependencies on older packages).

  Is it possible to generate unwanted packages list, which needs to be
removed before installation and ordered list of packages to build? I can
build them manually, but I need to know order and what to be uninstalled
before building...

-- 
  With respect
                                                   Serg.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
