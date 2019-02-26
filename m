From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Tue, 26 Feb 2019 11:15:38 -0600
Message-ID: <9a64ce0c-8ffd-73ee-3ba6-a8f98acf2b1e@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
 <20190223092820.GN23561@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190223092820.GN23561@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 2/23/2019 3:28 AM, Leon Romanovsky wrote:
> On Thu, Feb 21, 2019 at 08:19:07AM -0800, Steve Wise wrote:
>> Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
>> RDMA_NLDEV_CMD_DELLINK API.
>>
>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>> ---
>>  rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
>>  1 file changed, 58 insertions(+), 16 deletions(-)
>>
> If my series go first, this patch won't be needed.
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Some changes are still needed because your iproute2 series that was
recently merged didn't include the kernel NEWLINK/DELLINK changes.   But
I've rebased this and all the IWPM changes are already there as part of
your series.

Thanks,

Steve.
