From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Launchpad linux-rdma group and rdma-core daily builds
Date: Tue, 07 Nov 2017 14:50:06 +0100
Message-ID: <1510062606.32330.13.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

as previously discussed, I created a linux-rdma group on Launchpad
(using this mailing list as contact address):
https://launchpad.net/~linux-rdma

In addition, I created a rdma-core project (owned by linux-rdma):
https://launchpad.net/rdma-core

I setup a git repository import for rdma-core:
https://code.launchpad.net/~linux-rdma/rdma-core/+git/master

Then I created a build recipe for rdma-core:
https://code.launchpad.net/~linux-rdma/+recipe/rdma-core-daily

which publishes the packages in the rdma-core-daily PPA:
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily

The package was built successfully for Ubuntu 16.04 (xenial) and newer.
The build fails for Ubuntu 14.04 (trusty) due to the missing
libsystemd-dev package. Thus I excluded Ubuntu 14.04 (trusty) from the
daily builds. The upload failure mails that you can see on the mailing
list probably came from the clashing auto build and my manual build
request.

I invite every rdma-core developer (but not users) to join the linux-
rdma Launchpad group. You need a Launchpad account and then you can
request to join the group.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Geschäftsführer: Achim Weiss, Matthias Steinberg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
