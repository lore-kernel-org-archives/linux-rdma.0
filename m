From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/rdmavt: restore IRQs on error path in rvt_create_ah()
Date: Fri, 28 Apr 2017 13:02:25 -0400
Message-ID: <1493398945.3041.157.camel@redhat.com>
References: <20170427091420.j7kl5tmzqnyami4s@mwanda>
         <418a9680-c856-5b9c-b3b5-c46aaa367882@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <418a9680-c856-5b9c-b3b5-c46aaa367882@intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Kamal Heib <kamalh@mellanox.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-27 at 13:14 -0400, Dennis Dalessandro wrote:
> On 04/27/2017 05:14 AM, Dan Carpenter wrote:
> > 
> > We need to call spin_unlock_irqrestore() instead of vanilla
> > spin_unlock() on this error path.
> > 
> > Fixes: 119a8e708d16 ("IB/rdmavt: Add AH to rdmavt")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> 

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

