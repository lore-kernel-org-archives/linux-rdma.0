From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 1/1] IB/srp: fix invalid indirect_sg_entries parameter
 value
Date: Tue, 3 Jan 2017 14:05:45 -0500 (EST)
Message-ID: <1556941108.12182872.1483470345023.JavaMail.zimbra@redhat.com>
References: <1483451474-8096-1-git-send-email-maxg@mellanox.com> <1483466372.16249.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483466372.16249.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Sent: Tuesday, January 3, 2017 12:59:49 PM
> Subject: Re: [PATCHv1 1/1] IB/srp: fix invalid indirect_sg_entries parameter value
> 
> On Tue, 2017-01-03 at 15:51 +0200, Max Gurtovoy wrote:
> > From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > After setting indirect_sg_entries module_param to huge value (e.g 500,000),
> > srp_alloc_req_data() fails to allocate indirect descriptors for the request
> > ring (kmalloc fails). This commit enforces the maximum value of
> > indirect_sg_entries
> > to be SG_MAX_SEGMENTS as signified in module param description.
> > 
> > Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/srp/ib_srp.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> > b/drivers/infiniband/ulp/srp/ib_srp.c
> > index 0f67cf9..ccdd2c2 100644
> > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> > @@ -3676,6 +3676,7 @@ static struct srp_function_template
> > ib_srp_transport_functions = {
> >  static int __init srp_init_module(void)
> >  {
> >  	int ret;
> > +	unsigned int max_indirect_sg_entries = SG_MAX_SEGMENTS;
> >  
> >  	if (srp_sg_tablesize) {
> >  		pr_warn("srp_sg_tablesize is deprecated, please use cmd_sg_entries\n");
> > @@ -3699,6 +3700,12 @@ static int __init srp_init_module(void)
> >  		indirect_sg_entries = cmd_sg_entries;
> >  	}
> >  
> > +	if (indirect_sg_entries > max_indirect_sg_entries) {
> > +		pr_warn("Clamping indirect_sg_entries to %u\n",
> > +			max_indirect_sg_entries);
> > +		indirect_sg_entries = max_indirect_sg_entries;
> > +	}
> > +
> >  	srp_remove_wq = create_workqueue("srp_remove");
> >  	if (!srp_remove_wq) {
> >  		ret = -ENOMEM;
> 
> Hello Max,
> 
> That's a good catch, but why has the max_indirect_sg_entries variable been
> introduced? Can it be left out?
> 
> Thanks,
> 
> Bart.N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+��ݢj"��

I have never had to set mine that high even when I was testing against the DDN arrays.
I run my tests with the module parameters set this way.

options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048 

I thought 2048 was the max.

parm:           indirect_sg_entries:Default max number of gather/scatter entries (default is 12, max is 2048) (uint)

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
