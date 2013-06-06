From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Thu, 6 Jun 2013 23:33:33 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
References: <51ADD489.3020902@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
 <51AEE53C.2090603@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
 <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B023B9.9050000-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <B14CD9423B77044390AF0A11A07F6D9D-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 10:52 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>> Haggai: A verb to resize a registration would probably be a helpful
>> step. MPI could maintain one registration that covers the sbrk
>> region and one registration that covers the heap, much easier than
>> searching tables and things.
> 
> That's a nice idea. Even without this verb, I think it is possible to
> develop a registration cache that covers those regions though. When you
> find out you have some part of your region not registered, you can
> register a new, larger region that covers everything you need. For new
> operations you only use the newer region. Once the previous, smaller
> region is not used, you de-register it.


I'm not sure what you mean.  Are you saying I should do something like this:

MPI_Init() {
// the first MPI function invoked
  mpi_sbrk_save = sbrk();
  ibv_reg_mr(..., 0, mpi_sbrk_save, ...);
  ...
}

MPI_Send(buffer, ...) {
  if (mpi_sbrk_save != sbrk())
      mpi_sbrk_save = sbrk();
      ibv_rereg_mr(..., 0, mpi_sbrk_save, ...);
  ...
}

I don't think this covers other memory regions, like those added via mmap, right?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
