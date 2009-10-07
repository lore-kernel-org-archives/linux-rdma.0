From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Wed, 7 Oct 2009 12:16:56 -0700
Message-ID: <20ADF14BE2B24B459DC3921F69449E61@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com> <4ACAF913.3050909@voltaire.com> <AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com> <20091006200739.GP5191@obsidianresearch.com> <B266C10D3C26431E8FF5012420132452@amr.corp.intel.com> <20091006231720.GR5191@obsidianresearch.com> <3F7D26D4BA1C46F18F2F87BDD7EB7F36@amr.corp.intel.com> <20091007052639.GB18578@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091007052639.GB18578-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>So, I'm just talking about the user space API, the others can be
>changed as necessary to align with it.
>
>This is open source, so choosing a technically better solution over a
>endlessly backwards compatible solution is done all the time and is
>normal, expected, etc. Cost of progress - that is the underlying
>rational of Documentation/stable_api_nonsense.txt, and it applies just
>as well to niche little user space libraries like these :)

stable_api_nonsense.txt only applies to the rdma_cm interface, not the ABI or a
user space library.  I believe that any change to the library or ABI that forces
applications to change would be detrimental to OFA and the stack as a whole, and
I do not see a compelling reason to make such a change.

Discarding the existing librdmacm interface and ABI are not viable options in my
opinion.

>The rdma_ucm interface would have to be extended to be able to do 100%
>of the functionality of the ib cm interface using the rdma_cm_id
>abstraction. This is very useful in of itself and much better than
>adding an obscure option to override the ARP query. For instance,
>other MPIs could immediately provide their users an option to use GID
>addresess directly and cut out the ARP overhead instantly with
>little code change.

rdma_cm rdma_resolve_addr may result in issuing an ARP query - it depends on the
transport and device capabilities.  I want to keep the other behavior of
librdmacm rdma_resolve_addr, and eliminate the ARP as unnecessary.  Other
options I looked at were using fields inside the struct sockaddr_in6 (yuck) or
letting a timeout of 0 indicate that ARP should not be used.  The latter leaves
the ABI intact.  The drawback is that the DGID could still be unknown, which
would result in rdma_cm rdma_resolve_route failing.  This may be acceptable.
 
An extension to the ABI is needed to allow user space to set the IB path.  The
proposed 'set_option' ABI could support passing multiple PRs to the kernel.  The
kernel implementation only handles one currently.

>From your other mails, it doesn't sound like you have an issue with an ABI
extension that allows setting the IB path record directly.  Is this correct, and
do you have an issue with the proposed implementation of that?

You do seem to disagree with the changes to allow user space to specify the IP
to DGID mapping.  Is there an alternative that you would agree with?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
