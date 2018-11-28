From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 16:21:48 -0600
Message-ID: <870b87fa-0485-5aee-239a-0312b34a4361@opengridcomputing.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
 <20181128182645.GJ4559@mtr-leonro.mtl.com>
 <fcc5af3c-4440-93ac-e6b4-212f5d1fbfe0@opengridcomputing.com>
 <20181128200412.GP4559@mtr-leonro.mtl.com>
 <ddbbc8b5-3a32-4eea-cc02-b3211d3d47bb@opengridcomputing.com>
 <20181128201303.GR4559@mtr-leonro.mtl.com>
 <d2aaeece-6491-b5f2-d1af-e6c327590cab@opengridcomputing.com>
 <20181128221711.GH19914@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128221711.GH19914@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org



On 11/28/2018 4:17 PM, Jason Gunthorpe wrote:
> On Wed, Nov 28, 2018 at 02:18:55PM -0600, Steve Wise wrote:
>>
>> On 11/28/2018 2:13 PM, Leon Romanovsky wrote:
>>> On Wed, Nov 28, 2018 at 02:07:29PM -0600, Steve Wise wrote:
>>>> On 11/28/2018 2:04 PM, Leon Romanovsky wrote:
>>>>> On Wed, Nov 28, 2018 at 01:08:05PM -0600, Steve Wise wrote:
>>>>>> On 11/28/2018 12:26 PM, Leon Romanovsky wrote:
>>>>>>> On Thu, Sep 13, 2018 at 10:19:21AM -0700, Steve Wise wrote:
>>>>>>>> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
>>>>>>>> device to a netdev interface.
>>>>>>>>
>>>>>>>> EG:
>>>>>>>>
>>>>>>>> rdma link add rxe_eth0 type rxe dev eth0
>>>>>>>> rdma link delete rxe_eth0
>>>>>>>>
>>>>>>>> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>>>>>>>>  rdma/link.c  | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>>  rdma/rdma.h  |   1 +
>>>>>>>>  rdma/utils.c |   2 +-
>>>>>>>>  3 files changed, 108 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/rdma/link.c b/rdma/link.c
>>>>>>>> index 7a6d4b7e356d..d4f76b0ce11f 100644
>>>>>>>> +++ b/rdma/link.c
>>>>>>>> @@ -14,6 +14,8 @@
>>>>>>>>  static int link_help(struct rd *rd)
>>>>>>>>  {
>>>>>>>>  	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
>>>>>>>> +	pr_out("Usage: %s link add NAME type TYPE dev DEV\n", rd->filename);
>>>>>>> I suggest to rename "dev" to be "netdev", because we are using "dev" for
>>>>>>> ib devices.
>>>>>> Yea ok.
>>>>>>
>>>>>>>> +	pr_out("Usage: %s link delete NAME type TYPE\n", rd->filename);
>>>>>>> Why do you need "type" for "delete" command?
>>>>>> Because the type is used in the kernel to find the appropriate link
>>>>>> ops.  I could change the kernel side to search all types for the device
>>>>>> name to delete? 
>>>>> I would say, yes.
>>>>> It makes "delete" operation more natural.
>>>>>
>>>>> Thanks
>>>> Perhaps.
>>>>
>>>> Note: 'ip link delete' takes a type as well...
>>> According to man section, yes.
>>> According to various guides, no.
>>> https://docs.fedoraproject.org/en-US/Fedora/20/html/Networking_Guide/sec-Configure_802_1Q_VLAN_Tagging_ip_Commands.html
>>>
>>> Thanks
>> It does make sense to not require type.  The name must be unique so that
>> should be enough.  I'll have to respin the kernel side though...
> The delete_link really should be an operation on the ib_device, not
> the link_ops thing. 
>
> That directly prevents mis-matching function callbacks..
>
> Jason
Looking at the rtnetlink newlink/dellink, I see they cache the link_ops
ptr in the net_device struct.  So when the link is deleted, then
appropriate driver-specific dellink function can be called after finding
the device to be deleted.  Should I do something along these lines?  IE
add a struct rdma_link_ops pointer to struct ib_device.

Steve.
