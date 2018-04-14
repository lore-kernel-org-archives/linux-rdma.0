From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Sat, 14 Apr 2018 09:05:42 -0700
Message-ID: <e4b6b26ff58ee1ec9f92efacdd37e8fabbb7c8d6.camel@perches.com>
References: <9ad4563e701a38915d58552f9eee5b3602833ddf.camel@wdc.com>
         <20180413172708.30286-1-gthelen@google.com>
         <b1f20a68-2ed4-935f-4a9c-8a28c142ceee@intel.com>
         <CAHH2K0YTCa99ZfCdvq0WEJVvszo7+kUiVP_cz0igqE4TZSNYGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHH2K0YTCa99ZfCdvq0WEJVvszo7+kUiVP_cz0igqE4TZSNYGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Thelen <gthelen@google.com>, dennis.dalessandro@intel.com
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2018-04-14 at 15:34 +0000, Greg Thelen wrote:
> On Sat, Apr 14, 2018 at 8:13 AM Dennis Dalessandro <
> dennis.dalessandro@intel.com> wrote:
> 
> > On 4/13/2018 1:27 PM, Greg Thelen wrote:
> > > Allow INFINIBAND without INFINIBAND_ADDR_TRANS.
> > > 
> > > Signed-off-by: Greg Thelen <gthelen@google.com>
> > > Cc: Tarick Bedeir <tarick@google.com>
> > > Change-Id: I6fbbf8a432e467710fa65e4904b7d61880b914e5
> > Forgot to remove the Gerrit thing.
> > -Denny
> 
> Ack.  My bad.  Will repost.  Unfortunately checkpatch didn't notice.

Probably because Change-Id: is after a Signed-off-by: line
