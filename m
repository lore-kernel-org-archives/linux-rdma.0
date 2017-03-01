From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Thu, 2 Mar 2017 00:38:34 +0200
Message-ID: <CAFgAxU9rTrwe8xq-qGmH74v+4kJKNF+4GG9b_kSB92M5a9wgog@mail.gmail.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <20170301001023.GA3001@phlsvsds.ph.intel.com> <CAFgAxU-Vf6RLEo8N=oya0X+WbneRHE1xa_-5GY+TEqo1wyzpow@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E67C5CA80@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67C5CA80-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 2, 2017 at 12:17 AM, Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > What happens if this is a dual port device and only one of the 2 IB
>> > ports are changed?  So many things like AH, Path Records, etc are tied to the
>> "device"
>> > but really they should be tied to the port.
>>
>> The newer ConnectX4 (and forward) devices expose a pci function per port, so
>> reconfiguring a port link layer will hotplug only that pci function.
>>
>
> Interesting...  Do you have a "struct ib_device" for each pci function?
>
> Ira
>

yes. that how mlx5 devices are mapped on the PCI bus. each will have a
separate function with single port.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
