From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH][v3.19.y-ckt] IB/ipoib: change init sequence ordering
Date: Thu, 02 Jul 2015 10:16:09 -0700
Message-ID: <1435857369.23145.2.camel@fourier>
References: <55942302.10602@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <55942302.10602@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Kamal Mostafa <kamal.mostafa@canonical.com>, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, roland@purestorage.com, ogerlitz@mellanox.com, erezsh@mellanox.com, alex.estrin@intel.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, kamalh@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Wed, 2015-07-01 at 13:27 -0400, Joseph Salisbury wrote:
> Hello,
> 
> Please consider including upstream commits
> be7aa663fc1d9156798f5af3c60e6df45e1fe5de and
> e135106fac9525352feb8e49077c8f46c3eaf288 in the next v3.19.y-ckt
> release.  They were included mainline as of v4.1-rc1.  These commits
> have been tested and confirmed to resolve
> http://bugs.launchpad.net/bugs/1467912 .
> 
> 
> commit be7aa663fc1d9156798f5af3c60e6df45e1fe5de
> Author: Doug Ledford <dledford@redhat.com>
> Date:   Sat Feb 21 19:27:00 2015 -0500
> 
>     IB/ipoib: change init sequence ordering
> 
> commit e135106fac9525352feb8e49077c8f46c3eaf288
> Author: Doug Ledford <dledford@redhat.com>
> Date:   Sat Feb 21 19:26:59 2015 -0500
> 
>     IB/ipoib: factor out ah flushing
> 
> The bug reporter states this bug is only happening with the 3.19 kernel,
> these commits may not be needed in other stable kernels.

Queued up for 3.19-stable.

And thanks very much for the extra analysis and ack on this, Doug.

 -Kamal
