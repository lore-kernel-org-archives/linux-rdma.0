From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: rdma-core: Location of 70-persistent-ipoib.rules
Date: Mon, 11 Sep 2017 13:33:47 +0200
Message-ID: <1505129627.3732.3.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

70-persistent-ipoib.rules is installed in /etc/udev/rules.d on Debian.
lintian complains about it:

E: udev-rule-in-etc
N:
N:   This package ships a udev rule and installs it under
N:   /etc/udev/rules.d, which is reserved for user-installed files. The
N:   correct directory for system rules is /lib/udev/rules.d.
N:
N:   Refer to https://bugs.debian.org/559208 for details.
N:
N:   Severity: important, Certainty: certain
N:
N:   Check: files, Type: binary, udeb
N:

Since 70-persistent-ipoib.rules is just a commented example, should we
better put it into /usr/share/doc/rdma-core instead (where udev.md is
placed)?

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
