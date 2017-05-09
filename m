From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: srp_daemon : =?UTF-8?Q?=E2=80=8BDisallow?=
 =?UTF-8?Q?_=E2=80=8Ball?= targets =?UTF-8?Q?=E2=80=8Bif?=
 =?UTF-8?Q?_=E2=80=8Bnot?= =?UTF-8?Q?_=E2=80=8Bexplicitly?=
 =?UTF-8?Q?_=E2=80=8Ballowed?= by default
Date: Tue, 09 May 2017 19:07:33 +0200
Message-ID: <1494349653.3752.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

srptools 1.0.3-2 in Debian disallows all targets if not explicitly
allowed by default. Motivation (taken from debian/changelog):

* Don't activate any targets per default. (Closes: #740945)
  This is more sensible than the previous default of bringing
  up all targets in the IB fabric upon boot. In a larger fabric
  with many storage targets available, most of the times only
  one or a few targets are wanted on a particular machine.

Do you agree and could you change the default upstream? I prefer not to
carry a different behavior in Debian alone.

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
