From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: Re: [PATCH net-next 01/10] net/smc: add missing dev_put
Date: Thu, 5 Oct 2017 09:54:08 +0200
Message-ID: <7961df23-1603-7853-5f3e-f31095aebba0@linux.vnet.ibm.com>
References: <20170920115813.63745-1-ubraun@linux.vnet.ibm.com>
 <20170920115813.63745-2-ubraun@linux.vnet.ibm.com>
 <VI1PR0502MB30089D06B9C95D682E21511BD17D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <VI1PR0502MB30089D06B9C95D682E21511BD17D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "jwi@linux.vnet.ibm.com" <jwi@linux.vnet.ibm.com>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "raspl@linux.vnet.ibm.com" <raspl@linux.vnet.ibm.com>
List-Id: linux-rdma@vger.kernel.org



On 10/02/2017 10:36 PM, Parav Pandit wrote:
> Hi Ursula, Dave, Hans,
> 
>> -----Original Message-----
>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>> owner@vger.kernel.org] On Behalf Of Ursula Braun
>> Sent: Wednesday, September 20, 2017 6:58 AM
>> To: davem@davemloft.net
>> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org; linux-
>> s390@vger.kernel.org; jwi@linux.vnet.ibm.com; schwidefsky@de.ibm.com;
>> heiko.carstens@de.ibm.com; raspl@linux.vnet.ibm.com;
>> ubraun@linux.vnet.ibm.com
>> Subject: [PATCH net-next 01/10] net/smc: add missing dev_put
>>
>> From: Hans Wippel <hwippel@linux.vnet.ibm.com>
>>
>> In the infiniband part, SMC currently uses get_netdev which calls dev_hold on
>> the returned net device. However, the SMC code never calls dev_put on that net
>> device resulting in a wrong reference count.
>>
>> This patch adds a dev_put after the usage of the net device to fix the issue.
>>
>> Signed-off-by: Hans Wippel <hwippel@linux.vnet.ibm.com>
>> Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
>> ---
>>  net/smc/smc_ib.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c index
>> 547e0e113b17..0b5852299158 100644
>> --- a/net/smc/smc_ib.c
>> +++ b/net/smc/smc_ib.c
>> @@ -380,6 +380,7 @@ static int smc_ib_fill_gid_and_mac(struct smc_ib_device
>> *smcibdev, u8 ibport)
>>  	ndev = smcibdev->ibdev->get_netdev(smcibdev->ibdev, ibport);
>>  	if (ndev) {
>>  		memcpy(&smcibdev->mac, ndev->dev_addr, ETH_ALEN);
>> +		dev_put(ndev);
> 
> I am sorry for providing late comments. smc_ib_fill_gid_and_mac() is not coded correctly.
> Few fixes are needed.
> 1. ULP such as SMC should not open code/deference any function pointer like get_netdev() of the IB device.
> 2. Replace ib_query_gid(..., NULL)
> With
> ib_query_gid(..., gid_attr);
> 
> Use gid_attr.ndev to get the MAC address.
> Do dev_put(gid_attr.ndev);
> 
> Code should look like below,
> 
> struct ib_gid_attr gid_attr;
> 
> rc = ib_query_gid(..., &gid_attr);
> if (rc || !gid_addr.ndev)
> 	return -ENODEV;
> else
> 	memcpy(smcibdev->mac, ndev->dev_addr, ETH_ALEN);
> dev_put(gid_addr.ndev);
> 

Thanks, Parav!
Following your fix ideas I plan to change the function into this one:

static int smc_ib_fill_gid_and_mac(struct smc_ib_device *smcibdev, u8 ibport)
{
        struct ib_gid_attr gattr;
        int rc;

        rc = ib_query_gid(smcibdev->ibdev, ibport, 0,
                          &smcibdev->gid[ibport - 1], &gattr);
        /* the SMC protocol requires specification of the roce MAC address;
         * if net_device cannot be determined, it can be derived from gid 0
         */
        if (rc)
                return rc;

        if (gattr.ndev) {
                memcpy(&smcibdev->mac, gattr.ndev->dev_addr, ETH_ALEN);
                dev_put(gattr.ndev);
        } else {
                memcpy(&smcibdev->mac[ibport - 1][0],
                       &smcibdev->gid[ibport - 1].raw[8], 3);
                memcpy(&smcibdev->mac[ibport - 1][3],
                       &smcibdev->gid[ibport - 1].raw[13], 3);
                smcibdev->mac[ibport - 1][0] &= ~0x02;
        }
        return 0;
}

If you agree, I will submit the corresponding patch including a
	Suggested-by: Parav Pandit <parav@mellanox.com>

Regards, Ursula
