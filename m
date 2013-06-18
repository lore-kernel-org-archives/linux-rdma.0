From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: config file lost
Date: Tue, 18 Jun 2013 12:03:37 +0300
Message-ID: <51C02269.5050105@mellanox.com>
References: <51BDB769.70107@mellanox.com> <51BF591B.4090002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BF591B.4090002-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 17/06/2013 21:44, Hal Rosenstock wrote:
> I'm not 100% sure about the origin of those RPMs but I think the 3.3.15
> one is RedHat packaged and the 3.3.16 appears to be PLD packaged and the
> processes are a little different. I suspect the 3.3.16 one is packaged
> with the spec file in the tree whereas RedHat uses their own spec file.
>
> FWIW it's simple to generate an up to date config file:
>
> opensm -c opensm.conf

Hal,

YES for your observations, that 3.3.15 was RHEL packages and the 3.3.16 
was built from the upstream spec. I know that
I can generate the config file using the method you suggested, however, 
does the upstream service scripts uses the location to which this is 
generated,  so things are plug-and-play, or I need to hack that somehow?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
