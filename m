From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Is SRP over RoCE possible?
Date: Tue, 14 Feb 2017 18:45:11 +0000
Message-ID: <1487097898.2466.8.camel@sandisk.com>
References: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoJEnRERRNm34u8yonJCDqAe1d68BYb_GBTmmxVpFxpZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <C1BCBF0F1D4406429730E1580B981354-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-02-14 at 11:24 -0700, Robert LeBlanc wrote:
> I'm trying to get SRP working on my ConnectX-4-LX cards to see if it
> has the same problem as iSER does. When I try to connect the initiator
> to the target I get that opensm is not running. I tried all the umad
> devices without any luck. I found that someone had to modify the
> source to get it to work with RDMACM [0] and then another thread that
> specified that an option had to be passed to the ib_srpt module, but I
> don't see that option in modinfo and the Readme mentioned in the
> thread is not there[1]. If SRP should work, can someone help me figure
> out what I'm doing wrong here.

Hello Robert,

This is not yet possible with the upstream SRP drivers. I'm waiting for
the standardization of SRP over RoCE to add such support to the upstream
SRP drivers. But this is already possible today with the following
drivers:
- At the initiator side: https://github.com/bvanassche/ib_srp-backport
- At the target side: the SCST core + the SCST ib_srpt target driver and
  something like the following in /etc/modprobe.d/ib_srpt.conf:
  options ib_srpt rdma_cm_port=5000
- Since neither ibsrpdm nor srp_daemon support SRP over RoCE, login has
  to be performed by writing a login string into
  /sys/class/infiniband_srp/*/add_target. The format of that login string
  is id_ext=$ioc_guid,ioc_guid=$ioc_guid,dest=$dest where ioc_guid is the
  following parameter from the target system:
  /sys/module/ib_srpt/parameters/srpt_service_guid
  and where dest is [<IPv4 address>|<IPv6 address>]:<SRP RDMA/CM port number>

BTW, I have used these drivers to test and improve the SoftRoCE driver.

Bart.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
