From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: WARNING: bad unlock balance in ucma_event_handler
Date: Mon, 10 Jun 2019 19:58:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373B3E99E60@ORSMSX109.amr.corp.intel.com>
References: <000000000000af6530056e863794@google.com>
 <20180613170543.GB30019@ziepe.ca> <20190610184853.GG63833@gmail.com>
 <20190610194732.GH18468@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190610194732.GH18468@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Eric Biggers <ebiggers@kernel.org>
Cc: syzbot <syzbot+e5579222b6a3edd96522@syzkaller.appspotmail.com>, "dasaratharaman.chandramouli@intel.com" <dasaratharaman.chandramouli@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "parav@mellanox.com" <parav@mellanox.com>, "roland@purestorage.com" <roland@purestorage.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

> That is as far as I can get, trying to figure out how to rework
> ctx->file to be properly ref counted, accessed and locked, is a major
> task.. I don't even know right now what migrate_id is supposed to be
> for :(

By default, events for a new connection (rdma_cm_id) go to the fd (rdma_cm_event_channel) associated with the listen.  This allows migrating those events to a different fd.

- Sean
