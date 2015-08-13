From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Thu, 13 Aug 2015 16:09:00 +0300
Message-ID: <55CC96EC.4020008@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il>
 <55B5404F.5040404@opengridcomputing.com>
 <000001d0ce23$27048810$750d9830$@opengridcomputing.com>
 <55C0F5B7.4040100@dev.mellanox.co.il>
 <00b001d0cfc4$f83a14c0$e8ae3e40$@opengridcomputing.com>
 <55C37F43.6080106@dev.mellanox.co.il>
 <005801d0d54c$6e1dc560$4a595020$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <005801d0d54c$6e1dc560$4a595020$@opengridcomputing.com>
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, dledford@redhat.com
Cc: infinipath@intel.com, sagig@mellanox.com, ogerlitz@mellanox.com, roid@mellanox.com, linux-rdma@vger.kernel.org, eli@mellanox.com, target-devel@vger.kernel.org, linux-nfs@vger.kernel.org, bfields@fieldses.org
List-Id: linux-rdma@vger.kernel.org

>
> Nic is silent...
>
> Sagi, do you have an ETA on when you can have the recode ready for detailed review and test? If we can't make linux-4.3, can we be early in staging it for linux-4.4?

Hi Steve,

I have something, but its not remotely close to be submission ready.
This ended up being a rewrite of the registration path which is pretty
convoluted at the moment. My aim is mostly simplifying it in a way that
iWARP support would be (almost) straight-forward...

I can send you my WIP to test.

Sagi.
