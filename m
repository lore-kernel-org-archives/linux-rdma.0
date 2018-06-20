From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/3]
Date: Wed, 20 Jun 2018 12:43:23 -0600
Message-ID: <20180620184323.GD27445@ziepe.ca>
References: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 20, 2018 at 09:28:39AM -0700, Dennis Dalessandro wrote:
> Hi Doug and Jason,
> 
> Here are a couple patches that we'd like to get into 4.18 rc cycle. These fix
> bugs and aren't too complex. One of them is an issue that Dan Carpenter just
> reported recently and is marked for stable.

All of these need Fixes lines for-rc and other than the last one the
commit messages are not good enough - talk about what user visible
effect this bug has.

Jason
