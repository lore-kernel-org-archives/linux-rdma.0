From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: config file lost
Date: Tue, 18 Jun 2013 07:19:43 -0400
Message-ID: <51C0424F.60307@dev.mellanox.co.il>
References: <51BDB769.70107@mellanox.com> <51BF591B.4090002@dev.mellanox.co.il> <51C02269.5050105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C02269.5050105-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/18/2013 5:03 AM, Or Gerlitz wrote:
> On 17/06/2013 21:44, Hal Rosenstock wrote:
>> I'm not 100% sure about the origin of those RPMs but I think the 3.3.15
>> one is RedHat packaged and the 3.3.16 appears to be PLD packaged and the
>> processes are a little different. I suspect the 3.3.16 one is packaged
>> with the spec file in the tree whereas RedHat uses their own spec file.
>>
>> FWIW it's simple to generate an up to date config file:
>>
>> opensm -c opensm.conf
> 
> Hal,
> 
> YES for your observations, that 3.3.15 was RHEL packages and the 3.3.16
> was built from the upstream spec. I know that
> I can generate the config file using the method you suggested, however,
> does the upstream service scripts uses the location to which this is
> generated,  

Is /etc/rdma a standard location in Linux ? Is it used by other RDMA
upstream components ?

Also, opensm doesn't by default use this location for the config file. I
expect that's dealt with by other scripts RedHat supplies.

> so things are plug-and-play, or I need to hack that somehow?

You would currently need to hack that.

-- Hal

> Or.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
