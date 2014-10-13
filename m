From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/9] IB/core: Introduce peer client interface
Date: Mon, 13 Oct 2014 12:32:09 +0200
Message-ID: <543BAA29.4020006@acm.org>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com> <1412602019-30659-2-git-send-email-yishaih@mellanox.com> <54350284.10107@acm.org> <c8f2826c385e413eaa5f442cdcb64eaa@AMSPR05MB422.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c8f2826c385e413eaa5f442cdcb64eaa-Vl31pUvGNwELId+1UC+8EGu6+pknBqLbXA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/12/14 14:03, Shachar Raindel wrote:
>> The kernel-doc output for the above comment block is incomplete. Please
>> fix this, and please also fix the warnings reported by the kernel-doc
>
> We are not sure what is the best way to document an operations struct
> using nanodocs.
> Looking at mmu_notifiers, they are documented inline, using a
> comment style that nanodoc can't parse
> (http://lxr.free-electrons.com/source/include/linux/mmu_notifier.h#L27 )
> Looking at the file_operations struct, there is no documentation
> whatsoever
> (http://lxr.free-electrons.com/source/include/linux/fs.h#L1482 )
> Looking at ib_device
> (http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L1436 ),
> again there is no documentation.
>
> I attach our current nanodoc parsable comment. No errors are now
> generated when running kernel-doc on the attached file.
> Is this what you are aiming at? Can you give an example for the proper
> way to format such comments?

Hello Sachar,

Please note that I'm not an expert with regard to kernel documentation 
formats. In my opinion the documentation in the attached header file is 
not only easy to read for humans but the scripts/kernel-doc tool also 
generates nicely formatted HTML documentation from that document so I'm 
happy with the documentation format that is used in that header file.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
