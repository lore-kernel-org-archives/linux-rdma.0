From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch 2/3] ib_srpt: checking NULL instead of ERR_PTR
Date: Fri, 3 Feb 2012 16:01:49 +0300
Message-ID: <CA+_b7DK-=ORJQ20aHE_aVgEud4vAPQG_sskOeMqftabzun0h+A@mail.gmail.com>
References: <20111104182732.GH5796@elgon.mountain>
	<1320443697.5859.171.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1320443697.5859.171.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On 11/5/11, Nicholas A. Bellinger <nab@risingtidesystems.com> wrote:
> On Fri, 2011-11-04 at 21:27 +0300, Dan Carpenter wrote:
>> transport_init_session() and target_fabric_configfs_init() don't
>> return NULL pointers, they only return ERR_PTRs or valid pointers.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Thanks for catching this breakage.  It appears that are a few other
> locations outside of ib_srpt where return checking for these two
> functions needs to be fixed as well.  I'll fix this up shortly.
>

All the others seem to fixed up.  It's just these two place which need
to be fixed still.  My patch still applies fine with a little fuzz.  ;)

regards,
dan carpenter
