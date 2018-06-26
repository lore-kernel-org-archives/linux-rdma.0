From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-rc 3/3] IB/hfi1: Fix incorrect mixing of ERR_PTR and
 NULL return values
Date: Tue, 26 Jun 2018 11:19:19 -0400
Message-ID: <cc4f30ab-3032-4220-ee41-2d547c8856fb@intel.com>
References: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
 <20180620162904.13582.22527.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620162904.13582.22527.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On 6/20/2018 12:29 PM, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl@intel.com>
> 
> The __get_txreq() function can return a pointer, ERR_PTR(-EBUSY),
> or NULL.  All of the relevant call sites look for IS_ERR, so the
> NULL return would lead to a NULL pointer exception.
> 
> Do not use the ERR_PTR mechanism for this function.
> 
> Update all call sites to handle the return value correctly.
> 
> Clean up error paths to reflect return value.
> 
> cc: <stable@vger.kernel.org> # 4.9.x+
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Reviewed-by: Kamenee Arumugam <kamenee.arumugam@intel.com>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Fixes: 45842abbb292 ("staging/rdma/hfi1: move txreq header code")

-Denny
