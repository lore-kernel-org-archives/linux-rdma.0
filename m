From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 22:01:51 +0900
Message-ID: <AANLkTik2XaM6qyUUc+uzYCzKL+zKbN5kHz2Kf8So8arC@mail.gmail.com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<4CFD4BEE.5070205@shiftmail.org>
	<20101206212759.GB16788@obsidianresearch.com>
	<20101207083911.2ab47a59@frecb012350.frec.bull.fr>
	<4CFE0638.2040105@voltaire.com>
	<20101207112739.0c95db46@frecb012350.frec.bull.fr>
	<4CFE0D7C.4020904@voltaire.com>
	<20101207124805.1fede78f@frecb012350.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101207124805.1fede78f-xRPE6/W2vR9iM9LT7/dT9zWMkbuR3peG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Basic Question.
  MTU size matched?? on 10GbE and Infiniband

BTW, could you tell me more detail about 10GbE configuration.
what kind of teaming are you using?? (ex IEEE802.3ad)
(It is my interest.)

--
Hiroyuki Sato.


2010/12/7 sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>:
> On Tue, 7 Dec 2010 12:33:32 +0200
> Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>
>> On 12/7/2010 12:27 PM, sebastien dugue wrote:
>> >
>> > =A0 =A0Huh? How do you do that?
>> see Documentation/infiniband/ipoib.txt on your clone of Linus tree o=
r if
>> you're not a developer, see
>> http://lxr.linux.no/#linux+v2.6.36/Documentation/infiniband/ipoib.tx=
t
>> the HCA you're using does support offloads, so you're probably runni=
ng
>> connected mode, use datagram
>
> =A0Right, I'm running in connected mode. Last time I checked, datagra=
m mode
> was far from connected mode performance wise.
>
> =A0S=E9bastien.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
