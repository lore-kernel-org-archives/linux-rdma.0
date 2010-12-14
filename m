From: "Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Subject: RE: [ewg] IPoIB to Ethernet routing performance
Date: Tue, 14 Dec 2010 16:35:06 -0000
Message-ID: <004e01cb9bac$dead9870$9c08c950$@com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>	<4CFD4BEE.5070205@shiftmail.org>	<20101206212759.GB16788@obsidianresearch.com> <4D06438C.9040307@shiftmail.org>
Reply-To: <richard.croucher-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D06438C.9040307-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Content-Language: en-gb
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jabe' <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'OF EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Qlogic claim their QLE7340 is lowest latency for MPI applications but it is
restricted to a single port.   I've not carried out IPoIB testing of this
card.  There are plenty of published results for the Mellanox ConnectX cards
which tend to account for the majority of HCA's deployed.

My opinion is that the Mellanox  ConnectX has more capabilities on board and
is probably the best all rounder, but the Qlogic TrueScale lets certain apps
get closer to the metal and therefore lower latency.

You really have to carry out your own testing, since it depends on what you
consider important. 

Richard

-----Original Message-----
From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
[mailto:ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Jabe
Sent: 13 December 2010 16:02
To: Jason Gunthorpe
Cc: linux-rdma; OF EWG
Subject: Re: [ewg] IPoIB to Ethernet routing performance

On 12/06/2010 10:27 PM, Jason Gunthorpe wrote:
> On Mon, Dec 06, 2010 at 09:47:42PM +0100, Jabe wrote:
>    
>> Technologies MT25204 [InfiniHost III Lx HCA]; and dual E5430 xeon
>> (not nehalem).
>>      
> Newer Mellanox cards have most of the offloads you see for ethernet so
> they get better performance. Plus>  Nehalem is just better at TCP in
> the first place..
>    

Very interesting

Do you know if new Qlogic IB cards like QLE7340 also have such offloads?

In general which brand would you recommend for IB and for IPoIB?

Thank you
_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
