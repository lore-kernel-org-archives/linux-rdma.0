From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: How to monitor traffic with IBoE/RoCEE?
Date: Fri, 26 Mar 2010 13:47:10 -0700
Message-ID: <4BAD1D4E.8060208@linux.vnet.ibm.com>
References: <4BABFD62.70608@linux.vnet.ibm.com>
	<382A478CAD40FA4FB46605CF81FE39F455FF9847@orsmsx507.amr.corp.intel.com>
	<4BACF226.6030201@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4BACF226.6030201-wbocuHtxKic@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom Ammon wrote:
> A widely-supported method for collecting statistics from ethernet
> switching devices is SNMP. As Woody said, you wouldn't manage your
> ethernet network any differently than you do now. In addition many many
> tools have been written to make use of SNMP counters, so you won't have
> a hard time finding tools, both commercial and open source.
> 
> Tom
> 
> On 03/26/2010 11:29 AM, Woodruff, Robert J wrote:
>> Pradeep wrote,
>>
>>   
>>> With IBoE/RoCEE, the traditional SM in IB clusters is not needed.
>>> Most of the current
>>> IB tools rely on the SM and PM to get packet and error statistics and
>>> so on. These
>>> won't be applicable with IBoE/RoCEE. netstat will have no value since
>>> the kernel
>>> has been bypassed. So, how does one monitor traffic in such a cluster?
>>>      
>> Some managed Ethernet switches have the ability to log into them and
>> get information
>> on packets transmited/received on each port and errors that are
>> detected. However,
>> these are typically proprietary. I am not sure about the Mellanox card.
>>
>> So I guess the answer is that you manage RoCCE and iWarp clusters just
>> like
>> you would any Ethernet cluster, with existing management tools that
>> are available
>> for managing Ethernet.
>>
>> woody

True, I suspected that would be the case. However, that means we are using
a different management model than with IB clusters. Hence, I was curious if
Mellanox had any tools to get say some hardware counters without going to a
different management model.

Thanks
Pradeep
