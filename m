From: Bob Biloxi <iambobbiloxi@gmail.com>
Subject: mlx4 - query regarding PF VF functionality division
Date: Mon, 23 Jun 2014 15:03:29 +0530
Message-ID: <CANwwZzWsjQwZB5Cc4Hyv2HQOLhAx6ycjf32UQG55zVX=Kmbi6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I was going through the Mellanox driver (mlx4) and then I had
difficulty understanding which portion of code corresponds to the one
executed by the PF(Physical Function Driver) and which portion of code
by (Virtual Function Driver) in the SRIOV mode.

My confusion is because, I was of the understanding that the QPs, CQs
(and their creation, state mgmt commands) etc are to be performed by
the virtual function driver(VF driver).


And the role of the physical function driver(PF driver) is to just
take care of the resource_tracker.c and ICM allocation.


But of late, I think I may have understood wrong. This is because
there is code that is specifically executed when mlx4_is_master is
true/false( indicating PF or VF).

And then, there is code which is not surrounded by this test, which
indicates it is executed in both cases(PF driver as well as VF
driver).

Is my understanding correct? If yes, then are the QPs, CQs and
ethernet tx, rx related functionality is executed both by master and
slave?

Is there any way we can clearly separate the files that are used by PF
vs the files that are used by VF in the (drivers/net/ethernet/mlx4
sub-directory)?

I would be really thankful and really appreciate all the
help/clarification I can get in understanding this.


Thank you so much.


Best Regards,
Bob
