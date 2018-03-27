From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 iproute2-next 1/8] rdma: include rdma-core
 <rdma/rdma_cma.h>
Date: Tue, 27 Mar 2018 07:23:27 -0600
Message-ID: <6392b5eb-4966-460c-0a63-ef3124399a9a@gmail.com>
References: <cover.1522097991.git.swise@opengridcomputing.com>
 <326e72eaa0a6ed3d42aa857f13c80232a2550c77.1522097991.git.swise@opengridcomputing.com>
 <20180327054622.GU1877@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327054622.GU1877@mtr-leonro.local>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Steve Wise <swise@opengridcomputing.com>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/26/18 11:46 PM, Leon Romanovsky wrote:
> On Mon, Mar 26, 2018 at 01:57:32PM -0700, Steve Wise wrote:
>> This avoids requiring rdma-core be installed on systems.
>>
>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>> ---
>>  rdma/include/rdma/rdma_cma.h | 728 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 728 insertions(+)
>>  create mode 100644 rdma/include/rdma/rdma_cma.h
>>
> 
> Steve,
> 
> Sorry for not spotting it before, you actually need only 3 enums for the
> cm_id_ps_to_str() from rdma_cma.h.
> 
> Simply copy/paste that enum into cm_id_ps_to_str().
> 
> Thanks
> 

I think this is Jason's point: if that enum is part of the UAPI why
isn't it part of a uapi header file?

We definitely do not want that entire header file brought in to iproute2
