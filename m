From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 00/20] IB/hfi1, qib, rdmavt: Another round of patches
 for 4.11
Date: Wed, 05 Apr 2017 14:50:19 -0400
Message-ID: <1491418219.2923.9.camel@redhat.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dean Luick <dean.luick@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Brian Welty <brian.welty@intel.com>, Easwar Hariharan <easwar.hariharan@intel.com>, stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-20 at 17:24 -0700, Dennis Dalessandro wrote:
> Doug,
> Here is another round of patches for 4.11. Included with the usual
> bug fixes
> and general improvements of particular interest are new versions of
> the two
> patches that you didn't take for the first set. The fault injection
> stuff.
> We decided to go ahead and use the already existing config variable
> for those.
> The other interesting thing here is a patch to the IB core for
> MGID/MLID
> checking.
> 
> Patches apply on top of Linus' master branch which includes your most
> recent
> pull request so this should apply equally well to your tree. Patches
> can 
> also be found in my GitHub repo at:
> https://github.com/ddalessa/kernel/tree/for-4.11

Hi Denny,

I've done a partial pull of this set.  I took the first 18 patches (I
fixed up the config option issue I brought up).  The 19th patch I'm
waiting for you to tell me if it would be possible to do something
other than a kernel module option, and patch 20 didn't apply and I
didn't take the time to try and apply it today (I can look at it later,
but I wanted to get your first 18 pushed out before I left for an appt
this afternoon).

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
